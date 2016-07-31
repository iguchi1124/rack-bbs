require 'rack'
require 'mysql2'
require 'erb'

class Application
  def initialize
    @status = 200
    @headers = {}
    @body = ['']
  end

  def call(env)
    @request = Rack::Request.new(env)

    case [@request.request_method, @request.path]
    when ['GET', '/comments']
      get_comments
    when ['POST', '/comments']
      create_comments
    else
      not_found
    end

    [@status, @headers, @body]
  end

  private

  def mysql_client
    @mysql_client ||= ::Mysql2::Client.new(hosqt: 'localhost', username: 'root', database: 'bbs')
  end

  def not_found
    @status = 404
  end

  def get_comments
    comments = mysql_client.query 'SELECT * FROM comments;'

    @headers['Content-Type'] = 'text/html'
    @body = [ERB.new(File.read('templates/comments.erb')).result(binding)]
  end

  def create_comments
    statement = mysql_client.prepare "INSERT INTO comments (content) VALUES (?);"
    statement.execute(@request.params['content'])
    comments = mysql_client.query 'SELECT * FROM comments;'

    @headers['Content-Type'] = 'text/html'
    @body = [ERB.new(File.read('templates/comments.erb')).result(binding)]
  end
end
