# require 'sinatra/base'
# require 'active_support/all'
# require './config'

# class Hornet < Sinatra::Base
#   configure :development do
#     register Sinatra::Reloader
#   end

#   helpers do
#     def require_param(param)
#       allowed = "ALLOWED_#{param.to_s.pluralize.upcase}".constantize
#       unless allowed.include?(params[param])
#         raise "Error: #{param} must be #{allowed.to_sentence(:two_words_connector => ' or ', :last_word_connector => ' or ')}, not #{params[param]}."
#       end
#       return params[param]
#     end
#   end

#   get '/:type/:slug/*.*' do
#     type = require_param(:type)
#     slug = require_param(:slug)

#     if ALLOWED_EXTS.include?(params[:splat].last)
#       extension = params[:splat].last
#     else
#       raise "Error: Allowed image extensions are #{ALLOWED_EXTS.to_sentence(:two_words_connector => ' or ', :last_word_connector => ' or ')}."
#     end
    
#     article_number = params[:splat].first.to_i

#     "Type: #{type}, Slug: #{slug}, Article: #{article_number}, Extension: #{extension}."
#   end
# end