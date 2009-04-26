#include <ruby.h>

#define BHEAP_BUFFER_DEFAULT 16
#define BHEAP_BUFFER_MAX_SIZE (LONG_MAX / sizeof(VALUE))

typedef struct {
  unsigned long length;
  unsigned long capacity;
  VALUE cmp;
  VALUE* buf;
} BHEAP;

static VALUE bheap_alloc(VALUE klass)
{
  BHEAP* pb = ALLOC(BHEAP);

  return Data_Wrap_Struct(klass, 0, -1, pb);
}

static VALUE bheap_initialize(int argc, VALUE* argv, VALUE self)
{
  if (argc > 1) {
    rb_raise(rb_eArgError, "wrong number of arguments");
  }

  BHEAP* pb;
  Data_Get_Struct(self, BHEAP, pb);

  if (argc == 1) {
    pb->cmp = *argv;
  } else {
    pb->cmp = rb_eval_string("lambda {|x, y| x <=> y}");
  }
  pb->length = 0;
  pb->capacity = BHEAP_BUFFER_DEFAULT;
  pb->buf = ALLOC_N(VALUE, BHEAP_BUFFER_DEFAULT);

  return Qnil;
}

static VALUE bheap_isEmpty(VALUE self)
{
  BHEAP* pb;
  Data_Get_Struct(self, BHEAP, pb);

  return (pb->length ? Qfalse : Qtrue);
}

static VALUE bheap_push(VALUE self, VALUE v)
{
  BHEAP* pb;
  Data_Get_Struct(self, BHEAP, pb);

  if (pb->length == BHEAP_BUFFER_MAX_SIZE) {
    rb_raise(rb_eArgError, "bheap size too big");
  }

  pb->buf[pb->length] = v;

  unsigned long c = pb->length;
  unsigned long p = (c - 1) / 2;

  VALUE args = rb_ary_new2(2);

  while (c > 0) {
    rb_ary_push(args, pb->buf[p]);
    rb_ary_push(args, v);
    if (1 == NUM2INT(rb_proc_call(pb->cmp, args))) {
      break;
    }
    rb_ary_clear(args);

    pb->buf[c] = pb->buf[p];
    c = p;
    p = (c - 1) / 2;
  }
  pb->buf[c] = v;

  pb->length++;

  if (pb->length == pb->capacity) {
    VALUE *p = ALLOC_N(VALUE, (pb->capacity + BHEAP_BUFFER_DEFAULT));
    memcpy((char*)p, (char*)pb->buf, (pb->capacity * sizeof(VALUE)));
    pb->buf = p;
    pb->capacity += BHEAP_BUFFER_DEFAULT;
  }

  rb_ary_free(args);

  return self;
}

static VALUE bheap_pop(VALUE self)
{
  BHEAP* pb;
  Data_Get_Struct(self, BHEAP, pb);

  if (pb->length == 0) {
    return Qnil;
  }

  VALUE v = pb->buf[pb->length - 1];
  pb->length--;

  if (pb->length == 0) {
    return v;
  }

  VALUE r = pb->buf[0];
  pb->buf[0] = v;
  unsigned long p = 0;
  unsigned long c = 2 * p + 1;

  VALUE args = rb_ary_new2(2);

  while (c < pb->length) {
    rb_ary_push(args, pb->buf[c]);
    rb_ary_push(args, pb->buf[c + 1]);
    if (((c + 1) < pb->length) && 
	(-1 == NUM2INT(rb_proc_call(pb->cmp, args)))) {
      c = c + 1;
    }
    rb_ary_clear(args);

    rb_ary_push(args, v);
    rb_ary_push(args, pb->buf[c]);
    if (1 == NUM2INT(rb_proc_call(pb->cmp, args))) {
      break;
    }
    rb_ary_clear(args);

    pb->buf[p] = pb->buf[c];
    p = c;
    c = 2 * p + 1;
  }
  pb->buf[p] =v;

  rb_ary_free(args);

  return r;
}

static VALUE bheap_top(VALUE self)
{
  BHEAP* pb;
  Data_Get_Struct(self, BHEAP, pb);

  if (pb->length) {
    return pb->buf[0];
  } else {
    return Qnil;
  }
}

void Init_bheap(void)
{
  VALUE BHeap;

  BHeap = rb_define_class("BHeap", rb_cObject);
  rb_define_alloc_func(BHeap, bheap_alloc);
  rb_define_private_method(BHeap, "initialize", bheap_initialize, -1);
  rb_define_method(BHeap, "empty?", bheap_isEmpty, 0);
  rb_define_method(BHeap, "push", bheap_push, 1);
  rb_define_method(BHeap, "pop", bheap_pop, 0);
  rb_define_method(BHeap, "top", bheap_top, 0);
}
