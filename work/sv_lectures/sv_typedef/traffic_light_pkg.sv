package traffic_light_pkg;

typedef enum logic [1:0]{
  GREEN = 2'b11,
  YELLOW = 2'b01,
  RED = 2'b10
} trafic_light_t;

/*
typedef enum {
  GREEN, YELLOW, RED
} trafic_light_t;
*/
// GREEN = 001
// YELLOW = 010
// RED = 100

endpackage
