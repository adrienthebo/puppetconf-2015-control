require 'sinatra'
require 'sinatra/json'
require 'json'

module Jargon

  def self.glossary_from_file(path)
    JSON.parse(File.read(path))
  end

  class API < Sinatra::Base

    @@glossary = Jargon.glossary_from_file(File.expand_path("jargon_file_glossary.json", File.dirname(__FILE__)))

    get '/all' do
      json @@glossary
    end

    get '/random' do
      idx = Random.new.rand(@@glossary.size)
      key = @@glossary.keys[idx]
      json({key => @@glossary[key]})
    end

    get '/entry/:entry' do
      if @@glossary.key?(params['entry'])
        json({params['entry'] => @@glossary[params['entry']]})
      else
        status 404
        json({params['entry'] => {"error" => "Entry not found"}})
      end
    end

    not_found do
      json({"error" => "URL Not found"})
    end
  end
end
