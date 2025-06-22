#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef enum CountdownCommand {
  Continue,
  Abort,
} CountdownCommand;

typedef enum TrafficLight {
  Red,
  Yellow,
  Green,
} TrafficLight;

typedef struct MyPoint {
  float x;
  float y;
} MyPoint;

void hello_devworld(void);

/**
 * Add two signed integers.
 *
 * On a 64-bit system, arguments are 32 bit and return type is 64 bit.
 */
long long add_numbers(int x, int y);

/**
 * Take a zero-terminated C string and return its length as a
 * machine-size integer.
 */
unsigned long string_length(const char *sz_msg);

struct MyPoint give_me_a_point(void);

float magnitude(struct MyPoint p);

enum TrafficLight what_colour(void);

unsigned long leven(const char *s1, const char *s2);

char *give_me_letter_a(unsigned long count);

void free_string(char *s);

void add_numbers_cb(int n1, int n2, void (*callback)(int));

void countdown(enum CountdownCommand (*callback)(int));
