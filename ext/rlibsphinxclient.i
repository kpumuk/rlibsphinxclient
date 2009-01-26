%module rlibsphinxclient
%{
#include <sphinxclient.h>
%}

%include "typemaps.i"

%newobject sphinx_create;

/* -----------------------------------------------------------------------------
 *  This section contains generic input parameter type mappings.
 * ----------------------------------------------------------------------------- */

// Processing (sphinx_bool) params
%typemap(in) sphinx_bool {
  switch(TYPE($input)) {
    case T_TRUE:
    case T_FALSE:
      $1 = $input == Qtrue ? SPH_TRUE : SPH_FALSE;
      break;
    default:
      SWIG_exception_fail(SWIG_TypeError, "in method '" "$symname" "', argument " "$argnum"" of type '" "$1_type""'");
      break;
  }
}

// Processing (sphinx_uint64_t *) params.
%typemap(in) sphinx_uint64_t * {
  int size = RARRAY_LEN($input), i;

  $1 = (sphinx_uint64_t *) malloc(size * sizeof(sphinx_uint64_t));
  VALUE *ptr = RARRAY_PTR($input); 
  for (i = 0; i < size; i++, ptr++) {
    $1[i] = NUM2ULL(*ptr);
  }
}

// Cleaning up (sphinx_uint64_t *) params.
%typemap(freearg) sphinx_uint64_t * {
  free((char *) $1);
}

// Processing (int *) params.
%typemap(in) int * {
  int size = RARRAY_LEN($input), i;

  $1 = (int *) malloc(size * sizeof(int));
  VALUE *ptr = RARRAY_PTR($input);
  for (i = 0; i < size; i++, ptr++) {
    $1[i] = NUM2INT(*ptr);
  }
}

// Cleaning up (int *) params.
%typemap(freearg) int * {
  free((char *) $1);
}

// Processing (char **) params.
%typemap(in) char ** {
  int size = RARRAY_LEN($input), i;

  $1 = (char **) malloc(size * sizeof(char *));
  VALUE *ptr = RARRAY_PTR($input);
  for (i = 0; i < size; i++, ptr++) {
    $1[i] = STR2CSTR(*ptr);
  }
}

// Cleaning up (char **) params.
%typemap(freearg) char ** {
  free((char *) $1);
}

/* -----------------------------------------------------------------------------
 *  This section contains sphinx_result return value type mappings
 *  (functions sphinx_query and sphinx_run_queries.)
 * ----------------------------------------------------------------------------- */

// Processing sphinx_run_queries return value (array of sphinx_result).
%typemap(out) (sphinx_result *) {
  int num_results = sphinx_get_num_results(arg1), i;

  $result = rb_ary_new();
  for (i = 0; i < num_results; i++) {
    rb_ary_store($result, i, convert_sphinx_result(arg1, $1 + i));
  }
}
sphinx_result * sphinx_run_queries(sphinx_client * client);

// Processing sphinx_query return value (single instance of sphinx_result).
%typemap(out) (sphinx_result *) {
  $result = convert_sphinx_result(arg1, $1);
}

/* -----------------------------------------------------------------------------
 *  This section contains type mappings for sphinx_build_excerpts function.
 * ----------------------------------------------------------------------------- */

// Processing sphinx_excerpt_options input parameter.
%typemap(in) sphinx_excerpt_options * (sphinx_excerpt_options opts, VALUE val) {
  Check_Type($input, T_HASH);
  sphinx_init_excerpt_options(&opts);
  
  // before_match
  val = rb_hash_aref($input, rb_str_new2("before_match"));
  if (val != Qnil) {
    Check_Type($input, T_STRING);
    opts.before_match = STR2CSTR(val);
  }

  // after_match
  val = rb_hash_aref($input, rb_str_new2("after_match"));
  if (val != Qnil) {
    Check_Type($input, T_STRING);
    opts.after_match = STR2CSTR(val);
  }

  // chunk_separator
  val = rb_hash_aref($input, rb_str_new2("chunk_separator"));
  if (val != Qnil) {
    Check_Type($input, T_STRING);
    opts.chunk_separator = STR2CSTR(val);
  }
  
  // limit
  val = rb_hash_aref($input, rb_str_new2("limit"));
  if (val != Qnil) {
    Check_Type($input, T_FIXNUM);
    opts.limit = NUM2INT(val);
  }
  
  // around
  val = rb_hash_aref($input, rb_str_new2("around"));
  if (val != Qnil) {
    Check_Type($input, T_FIXNUM);
    opts.around = NUM2INT(val);
  }

  // exact_phrase
  val = rb_hash_aref($input, rb_str_new2("exact_phrase"));
  if (val != Qnil) {
    opts.around = val == Qtrue ? SPH_TRUE : SPH_FALSE;
  }

  // single_passage
  val = rb_hash_aref($input, rb_str_new2("single_passage"));
  if (val != Qnil) {
    opts.single_passage = val == Qtrue ? SPH_TRUE : SPH_FALSE;
  }

  // use_boundaries
  val = rb_hash_aref($input, rb_str_new2("use_boundaries"));
  if (val != Qnil) {
    opts.use_boundaries = val == Qtrue ? SPH_TRUE : SPH_FALSE;
  }

  // weight_order
  val = rb_hash_aref($input, rb_str_new2("weight_order"));
  if (val != Qnil) {
    opts.weight_order = val == Qtrue ? SPH_TRUE : SPH_FALSE;
  }
  
  $1 = &opts;
}

// Processing char ** output parameter.
%typemap(out) char ** {
  int num_docs, i;
  
  SWIG_AsVal_int(argv[1], &num_docs);
  
  if ($1) {
    $result = rb_ary_new();
    for (i = 0; i < num_docs; i++) {
      rb_ary_store($result, i, rb_str_new2($1[i]));
    
      free((char *) $1[i]);
    }
    free((char *) $1);
  } else {
    $result = Qfalse;
  }
}
char ** sphinx_build_excerpts(sphinx_client * client, int num_docs, const char ** docs, const char * index, const char * words, sphinx_excerpt_options * opts);
%typemap(in) sphinx_excerpt_options * {}
%typemap(out) char ** {}

/* -----------------------------------------------------------------------------
 *  This section contains type mappings for sphinx_build_keywords function.
 * ----------------------------------------------------------------------------- */

// Defining out_num_keywords input parameter (will contain a number of keywords).
%typemap(in, numinputs = 0) int * out_num_keywords (int out_num_keywords) {
  $1 = &out_num_keywords;
}

// Doing nothing because out_num_keywords is a local variable.
%typemap(freearg) int * out_num_keywords {
}

// Processing array of sphinx_keyword_info values.
%typemap(out) sphinx_keyword_info * {
  int i;
  VALUE keyword = Qnil;
  $result = rb_ary_new();
  for (i = 0; i < out_num_keywords5; i++) {
    keyword = rb_hash_new();
    rb_hash_aset(keyword, rb_str_new2("tokenized"), rb_str_new2($1[i].tokenized));
    rb_hash_aset(keyword, rb_str_new2("normalized"), rb_str_new2($1[i].normalized));
    rb_hash_aset(keyword, rb_str_new2("docs"), INT2FIX($1[i].num_docs));
    rb_hash_aset(keyword, rb_str_new2("hits"), INT2FIX($1[i].num_hits));
    rb_ary_store($result, i, keyword);
    
    free((char *) $1[i].tokenized);
    free((char *) $1[i].normalized);
  }
  
  free((char *) $1);
}

/* -----------------------------------------------------------------------------
 *  This section contains some useful helpers for type mappers.
 * ----------------------------------------------------------------------------- */

%{
static VALUE convert_sphinx_result(sphinx_client *client, sphinx_result *input) {
  int i, j, k;
  VALUE result = Qnil, var1 = Qnil, var2 = Qnil, var3 = Qnil, var4 = Qnil;
  char *msg = (char *) 0;
  unsigned int *mva = 0;
  char *time = 0;
  
  if (!input) {
    result = Qfalse;
  } else {
    result = rb_hash_new();
    rb_hash_aset(result, rb_str_new2("error"), input->error ? rb_str_new2(input->error) : Qnil);
    rb_hash_aset(result, rb_str_new2("warning"), input->warning ? rb_str_new2(input->warning) : Qnil);
    rb_hash_aset(result, rb_str_new2("status"), INT2FIX(input->status));
    if (input->status != SEARCHD_OK && input->status != SEARCHD_WARNING) {
      return result;
    }
    
    rb_hash_aset(result, rb_str_new2("total"), INT2FIX(input->total));
    rb_hash_aset(result, rb_str_new2("total_found"), INT2FIX(input->total_found));
    time = (char *) malloc(20);
    sprintf(time, "%.3f", input->time_msec / 1000.);
    rb_hash_aset(result, rb_str_new2("time"), rb_str_new2(time));
    free(time);
  
    // fields
    var1 = rb_ary_new();
    for (i = 0; i < input->num_fields; i++) {
      rb_ary_store(var1, i, rb_str_new2(input->fields[i]));
    }
    rb_hash_aset(result, rb_str_new2("fields"), var1);
  
    // attrs
    var1 = rb_hash_new();
    for (i = 0; i < input->num_attrs; i++) {
      rb_hash_aset(var1, rb_str_new2(input->attr_names[i]), INT2NUM(input->attr_types[i]));    
    }
    rb_hash_aset(result, rb_str_new2("attrs"), var1);    
  
    // words
    var1 = rb_hash_new();
    for (i = 0; i < input->num_words; i++) {
      var2 = rb_hash_new();
      rb_hash_aset(var2, rb_str_new2("docs"), INT2FIX(input->words[i].docs));
      rb_hash_aset(var2, rb_str_new2("hits"), INT2FIX(input->words[i].hits));
  
      rb_hash_aset(var1, rb_str_new2(input->words[i].word), var2);
    }
    rb_hash_aset(result, rb_str_new2("words"), var1);

    // matches
    var1 = rb_ary_new();
    for (i = 0; i < input->num_matches; i++) {
      var2 = rb_hash_new();
      rb_hash_aset(var2, rb_str_new2("id"), ULL2NUM(sphinx_get_id(input, i)));
      rb_hash_aset(var2, rb_str_new2("weight"), INT2FIX(sphinx_get_weight(input, i)));
      
      var3 = rb_hash_new();
      for (j = 0; j < input->num_attrs; j++) {
        switch (input->attr_types[j]) {
          case SPH_ATTR_MULTI | SPH_ATTR_INTEGER:
            mva = (unsigned int *) sphinx_get_mva(input, i, j);
            var4 = rb_ary_new();
            for (k = 0; k < (int) mva[0]; k++) {
              rb_ary_store(var4, k, INT2NUM(mva[k + 1]));
            }
            break;
          case SPH_ATTR_FLOAT:
            var4 = rb_float_new(sphinx_get_float(input, i, j));
            break;
          default:
            var4 = ULL2NUM(sphinx_get_int(input, i, j));
            break;
        }
        rb_hash_aset(var3, rb_str_new2(input->attr_names[j]), var4);
      }
      rb_hash_aset(var2, rb_str_new2("attrs"), var3);
      
      rb_ary_store(var1, i, var2);
    }
    rb_hash_aset(result, rb_str_new2("matches"), var1);
  }
  
  return result;
}
%}

%include "/opt/sphinx-0.9.9/include/sphinxclient.h"
