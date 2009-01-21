module Sphinx
  class FastClient
    Lib = Rlibsphinxclient

    def initialize
      @sphinx = Lib.sphinx_create(Lib::SPH_TRUE)
    end
    
    def destroy
      Lib.sphinx_destroy(@sphinx)
      @sphinx = nil
    end
    
    def GetLastError
      Lib.sphinx_error(@sphinx)
    end

    def GetLastWarning
      Lib.sphinx_warning(@sphinx)
    end
    
    def SetServer(host, port)
      Lib.sphinx_set_server(@sphinx, host, port)
    end

    def SetConnectionTimeout(seconds)
      Lib.sphinx_set_connect_timeout(@sphinx, seconds)
    end

    def SetLimits(offset, limit, max_matches = 0, cutoff = 0)
      Lib.sphinx_set_limits(@sphinx, offset, limit, max_matches, cutoff)
    end

    def SetMaxQueryTime(max_query_time)
      Lib.sphinx_set_max_query_time(@sphinx, max_query_time)
    end

    def SetMatchMode(mode)
      mode = Lib.const_get("SPH_MATCH_#{mode.to_s.upcase}") if mode.is_a? Symbol
      Lib.sphinx_set_match_mode(@sphinx, mode)
    end
    
    def SetRankingMode(ranker)
      ranker = Lib.const_get("SPH_RANK_#{ranker.to_s.upcase}") if ranker.is_a? Symbol
      Lib.sphinx_set_ranking_mode(@sphinx, ranker)
    end
    
    def SetSortMode(mode, sortby = '')
      mode = Lib.const_get("SPH_SORT_#{mode.to_s.upcase}") if mode.is_a? Symbol
      Lib.sphinx_set_sort_mode(@sphinx, mode, sortby)
    end
    
    def SetFieldWeights(weights)
      puts weights.keys.inspect
      Lib.sphinx_set_field_weights(@sphinx, weights.size, weights.keys, weights.values)
    end
    
    def SetIndexWeights(weights)
      Lib.sphinx_set_index_weights(@sphinx, weights.size, weights.keys, weights.values)
    end
    
    def SetIDRange(min, max)
      Lib.sphinx_set_id_range(@sphinx, min, max)
    end
    
    def SetFilter(attribute, values, exclude = false)
      Lib.sphinx_add_filter(@sphinx, attribute, values.length, values, exclude ? Lib::SPH_TRUE : Lib::SPH_FALSE)
    end

    def SetFilterRange(attribute, min, max, exclude = false)
      Lib.sphinx_add_filter_range(@sphinx, attribute, min, max, exclude ? Lib::SPH_TRUE : Lib::SPH_FALSE)
    end
    
    def SetFilterFloatRange(attribute, min, max, exclude = false)
      Lib.sphinx_add_filter_float_range(@sphinx, attribute, min, max, exclude ? Lib::SPH_TRUE : Lib::SPH_FALSE)
    end
    
    def SetGeoAnchor(attrlat, attrlong, lat, long)
      Lib.sphinx_set_geoanchor(@sphinx, attrlat, attrlong, lat, long)
    end
    
    def SetGroupBy(attribute, func, groupsort = '@group desc')
      Lib.sphinx_set_groupby(@sphinx, attribute, func, groupsort)
    end
    
    def SetGroupDistinct(attribute)
      Lib.sphinx_set_groupby_distinct(@sphinx, attribute)
    end
    
    def SetRetries(count, delay = 0)
      Lib.sphinx_set_retries(@sphinx, count, delay)
    end
    
    def ResetFilters
      Lib.sphinx_reset_filters(@sphinx)
    end
    
    def ResetGroupBy
      Lib.sphinx_reset_groupby(@sphinx)
    end
    
    def Query(query, index = '*', comment = '')
      Lib.sphinx_query(@sphinx, query, index, comment)
    end
    
    def AddQuery(query, index = '*', comment = '')
      Lib.sphinx_add_query(@sphinx, query, index, comment)
    end
    
    def RunQueries
      Lib.sphinx_run_queries
    end

    # int             sphinx_get_num_results      ( sphinx_client * client );

    # void            sphinx_init_excerpt_options   ( sphinx_excerpt_options * opts );
    # char **           sphinx_build_excerpts     ( sphinx_client * client, int num_docs, const char ** docs, const char * index, const char * words, sphinx_excerpt_options * opts );
    # int             sphinx_update_attributes    ( sphinx_client * client, const char * index, int num_attrs, const char ** attrs, int num_docs, const sphinx_uint64_t * docids, const sphinx_uint64_t * values );
    # sphinx_keyword_info *   sphinx_build_keywords     ( sphinx_client * client, const char * query, const char * index, sphinx_bool hits, int * out_num_keywords );
    
    def BuildExcerpts(docs, index, words, opts = {})
      
    end
    
    def BuildKeywords(query, index, hits)
    end
    
    def UpdateAttributes(index, attrs, values, mva = false)
    end
  end
end