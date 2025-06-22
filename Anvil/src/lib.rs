use once_cell::sync::OnceCell;
use std::ffi::{CStr, CString};
use std::os::raw::c_float;
use std::os::raw::{c_char, c_int, c_longlong, c_ulong};
use std::thread;
use std::time::Duration;

use tokio::runtime::Runtime;

static RUNTIME: OnceCell<Runtime> = OnceCell::new();

fn get_runtime() -> &'static Runtime {
    RUNTIME.get_or_init(|| Runtime::new().expect("Failed to create Tokio runtime"))
}

#[unsafe(no_mangle)]
pub extern "C" fn hello_devworld() {
    println!("Hello, new life");
}

/// Add two signed integers.
///
/// On a 64-bit system, arguments are 32 bit and return type is 64 bit.
#[unsafe(no_mangle)]
pub extern "C" fn add_numbers(x: c_int, y: c_int) -> c_longlong {
    get_runtime().spawn(async {
        tokio::time::sleep(Duration::from_secs(3)).await;
        println!("printing in an async task!!!!");
    });
    x as c_longlong + y as c_longlong
}

/// Take a zero-terminated C string and return its length as a
/// machine-size integer.
#[unsafe(no_mangle)]
pub extern "C" fn string_length(sz_msg: *const c_char) -> c_ulong {
    let slice = unsafe { CStr::from_ptr(sz_msg) };
    slice.to_bytes().len() as c_ulong
}

// You can combine this with the `use` at the top of the file if you wish
// Or leave it separate, it doesn't matter

#[repr(C)]
pub struct MyPoint {
    pub x: c_float,
    pub y: c_float,
}

#[unsafe(no_mangle)]
pub extern "C" fn give_me_a_point() -> MyPoint {
    MyPoint { x: 3.14, y: 12.0 }
}

#[unsafe(no_mangle)]
pub extern "C" fn magnitude(p: MyPoint) -> c_float {
    (p.x * p.x + p.y * p.y).sqrt()
}

#[repr(C)]
pub enum TrafficLight {
    Red,
    Yellow,
    Green,
}

#[unsafe(no_mangle)]
pub extern "C" fn what_colour() -> TrafficLight {
    TrafficLight::Green
}

#[unsafe(no_mangle)]
pub extern "C" fn leven(s1: *const c_char, s2: *const c_char) -> c_ulong {
    let s1 = unsafe { CStr::from_ptr(s1) };
    let s1 = s1.to_str().unwrap();
    let s2 = unsafe { CStr::from_ptr(s2) };
    let s2 = s2.to_str().unwrap();
    levenshtein::levenshtein(s1, s2) as c_ulong
}

#[unsafe(no_mangle)]
pub extern "C" fn give_me_letter_a(count: c_ulong) -> *mut c_char {
    let string = "A".repeat(count as usize);
    let cstring = CString::new(string).unwrap();
    cstring.into_raw()
}

#[unsafe(no_mangle)]
pub extern "C" fn free_string(s: *mut c_char) {
    let cstring = unsafe { CString::from_raw(s) };
    drop(cstring); // not technically required but shows what we're doing
}

#[unsafe(no_mangle)]
pub extern "C" fn add_numbers_cb(n1: c_int, n2: c_int, callback: fn(c_int)) {
    let answer = n1 + n2;
    callback(answer);
}

// #[unsafe(no_mangle)]
// pub extern "C" fn countdown(callback: fn(c_int)) {
//     // Moving the callback fn ptr into the thread
//     thread::spawn(move || {
//         for x in (0..=15).rev() {
//             thread::sleep(Duration::from_secs(1));
//             callback(x);
//         }
//     });
// }

#[repr(C)]
pub enum CountdownCommand {
    Continue,
    Abort,
}

#[unsafe(no_mangle)]
pub extern "C" fn countdown(callback: fn(c_int) -> CountdownCommand) {
    // Moving the callback fn ptr into the thread
    thread::spawn(move || {
        for x in (0..=15).rev() {
            thread::sleep(Duration::from_secs(1));
            match callback(x) {
                CountdownCommand::Continue => continue,
                CountdownCommand::Abort => break,
            }
        }
    });
}
