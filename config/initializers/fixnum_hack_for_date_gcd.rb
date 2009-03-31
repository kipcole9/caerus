#Source: http://kurtstephens.com/node/34
# Helps with date-intensive activities by about 15%
require 'inline'

class Fixnum
  inline do | builder |
    builder.c_raw '
    static
    VALUE 
    gcd(int argc, VALUE *argv, VALUE self) {
      if ( argc != 1 ) {
        rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)",
                 argc, 1);
      }
      /* Handle Fixnum#gcd(Fixnum) case directly. */
      if ( FIXNUM_P(argv[0]) ) {
        /* fprintf(stderr, "Using Fixnum#gcd(Fixnum)\n"); */
        long a = FIX2LONG(self);
        long b = FIX2LONG(argv[0]);
        long min = a < 0 ? - a : a;
        long max = b < 0 ? - b : b;
        while ( min > 0 ) {
          int tmp = min;
          min = max % min;
          max = tmp;
        }
        return LONG2FIX(max);
      } else {
        /* fprintf(stderr, "Using super#gcd\n"); */
        return rb_call_super(1, argv);
      }
    }
    '
  end
end