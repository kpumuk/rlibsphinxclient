%module rlibsphinxclient
%{
#include <sphinxclient.h>
%}

%include "typemaps.i"

%newobject sphinx_create;

// Processing (sphinx_bool) params
%typemap(in) sphinx_bool {
  switch(TYPE($input)) {
    case T_TRUE:
    case T_FALSE:
      $1 = $input == Qtrue ? 1 : 0;
      break;
    default:
      SWIG_exception_fail(SWIG_TypeError, "in method '" "$symname" "', argument " "$argnum"" of type '" "$1_type""'");
      break;
  }
}

// Processing (sphinx_uint64_t *) params
%typemap(in) sphinx_uint64_t * {
  /* Get the length of the array */
  int size = RARRAY($input)->len;
  int i;
  $1 = (sphinx_uint64_t *) malloc(size * sizeof(sphinx_uint64_t));
  /* Get the first element in memory */
  VALUE *ptr = RARRAY($input)->ptr; 
  for (i = 0; i < size; i++, ptr++) {
    /* Convert Ruby Object String to char* */
    $1[i]= NUM2ULL(*ptr);
  }
}

// This cleans up the char (sphinx_uint64_t *) array created before 
// the function call
%typemap(freearg) sphinx_uint64_t * {
  free((char *) $1);
}

// Processing (int *) params
%typemap(in) int * {
  /* Get the length of the array */
  int size = RARRAY($input)->len;
  int i;
  $1 = (int *) malloc(size * sizeof(int));
  /* Get the first element in memory */
  VALUE *ptr = RARRAY($input)->ptr; 
  for (i = 0; i < size; i++, ptr++) {
    /* Convert Ruby Object String to char* */
    $1[i]= NUM2INT(*ptr);
  }
}

// This cleans up the char (sphinx_uint64_t *) array created before 
// the function call
%typemap(freearg) int * {
  free((char *) $1);
}

// Processing (char **) params
%typemap(in) char ** {
  /* Get the length of the array */
  int size = RARRAY($input)->len; 
  int i;
  $1 = (char **) malloc((size + 1) * sizeof(char *));
  /* Get the first element in memory */
  VALUE *ptr = RARRAY($input)->ptr; 
  for (i = 0; i < size; i++, ptr++) {
    /* Convert Ruby Object String to char* */
    $1[i]= STR2CSTR(*ptr); 
  }
  $1[i] = NULL; /* End of list */
}

// This cleans up the char ** array created before 
// the function call

%typemap(freearg) char ** {
  free((char *) $1);
}

// Sphinx search results

%typemap(out) (sphinx_result *) {
  int i, j, k;
  VALUE var1 = Qnil, var2 = Qnil, var3 = Qnil, var4 = Qnil;
  unsigned int *mva = 0;
  char *time = 0;
  
  if (!$1) {
    $result = Qfalse;
  } else {
    $result = rb_hash_new();
    rb_hash_aset($result, rb_str_new2("status"), INT2FIX($1->status));
    
    rb_hash_aset($result, rb_str_new2("error"), Qnil);
    rb_hash_aset($result, rb_str_new2("warning"), $1->warning ? rb_str_new2($1->warning) : Qnil);
    rb_hash_aset($result, rb_str_new2("total"), INT2FIX($1->total));
    rb_hash_aset($result, rb_str_new2("total_found"), INT2FIX($1->total_found));
    time = (char *) malloc(20);
    sprintf(time, "%%.3f", $1->time_msec / 1000.);
    rb_hash_aset($result, rb_str_new2("time"), rb_str_new2(time));
    free(time);
  
    // fields
    var1 = rb_ary_new();
    for (i = 0; i < $1->num_fields; i++) {
      rb_ary_store(var1, i, rb_str_new2($1->fields[i]));
    }
    rb_hash_aset($result, rb_str_new2("fields"), var1);
  
    // attrs
    var1 = rb_hash_new();
    for (i = 0; i < $1->num_attrs; i++) {
      rb_hash_aset(var1, rb_str_new2($1->attr_names[i]), SWIG_From_int($1->attr_types[i]));    
    }
    rb_hash_aset($result, rb_str_new2("attrs"), var1);    
  
    // words
    var1 = rb_hash_new();
    for (i = 0; i < $1->num_words; i++) {
      var2 = rb_hash_new();
      rb_hash_aset(var2, rb_str_new2("docs"), INT2FIX($1->words[i].docs));
      rb_hash_aset(var2, rb_str_new2("hits"), INT2FIX($1->words[i].hits));
  
      rb_hash_aset(var1, rb_str_new2($1->words[i].word), var2);
    }
    rb_hash_aset($result, rb_str_new2("words"), var1);

    // matches
    var1 = rb_ary_new();
    for (i = 0; i < $1->num_matches; i++) {
      var2 = rb_hash_new();
      rb_hash_aset(var2, rb_str_new2("id"), INT2FIX(sphinx_get_id($1, i)));
      rb_hash_aset(var2, rb_str_new2("weight"), INT2FIX(sphinx_get_weight($1, i)));
      
      var3 = rb_hash_new();
      for (j = 0; j < $1->num_attrs; j++) {
        switch ($1->attr_types[j]) {
          case SPH_ATTR_MULTI | SPH_ATTR_INTEGER:
            mva = (unsigned int *)sphinx_get_mva($1, i, j);
            var4 = rb_ary_new();
            for (k = 0; k < (int) mva[0]; k++) {
              rb_ary_store(var4, k, INT2FIX(mva[k + 1]));
            }
            break;
          case SPH_ATTR_FLOAT:
            var4 = SWIG_From_float(sphinx_get_float($1, i, j));
            break;
          default:
            var4 = SWIG_From_int(sphinx_get_int($1, i, j));
            break;
        }
        rb_hash_aset(var3, rb_str_new2($1->attr_names[j]), var4);
      }
      rb_hash_aset(var2, rb_str_new2("attrs"), var3);
      
      rb_ary_store(var1, i, var2);
    }
    rb_hash_aset($result, rb_str_new2("matches"), var1);
  }
};

%include "/opt/sphinx-0.9.9/include/sphinxclient.h"
