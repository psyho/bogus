Bogus can be configured, similarly to many other frameworks with a configure block. 

    Bogus.configure do |c|
      c.search_modules = [Object]
      c.fake_ar_attributes = true
    end

