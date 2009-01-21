%module rlibsphinxclient
%{
#include <sphinxclient.h>
%}

%include "typemaps.i"

%newobject sphinx_create;

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
    time = (char *)malloc(20);
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
