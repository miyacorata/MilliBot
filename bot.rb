require 'rubygems'
require 'bundler/setup'
require 'mastodon'
require 'mysql2'
require 'dotenv'
require 'oauth2'
require 'date'

puts "#= MilliBot started up. =#\n"

Dotenv.load

# アクセストークンの確認あるいは取得
unless ENV['ACCESS_TOKEN']
  client = OAuth2::Client.new(ENV['CLIENT_KEY'], ENV['CLIENT_SECRET'],
                              site: ENV['MASTODON_URL'])
  print 'Your Mail : '
  user_id = gets.chomp
  print 'Password  : '
  password = gets.chomp
  token = client.password.get_token(user_id, password, scope: ENV['CLIENT_SCOPE'])
  ENV['ACCESS_TOKEN'] = token.token
  File.open('.env', 'a+') do |f|
    f.write "\nACCESS_TOKEN = '#{ENV['ACCESS_TOKEN']}'\n"
  end
end

client = Mastodon::REST::Client.new(base_url: ENV['MASTODON_URL'],
                                    bearer_token: ENV['ACCESS_TOKEN'])

mysql = Mysql2::Client.new(host: ENV['MYSQL_HOST'], username: ENV['MYSQL_USER'],
                           password: ENV['MYSQL_PASS'], database: ENV['MYSQL_DBNAME'])

statement = mysql.prepare('SELECT name,subname,type,age FROM CGP_Idol WHERE birthdate = ? ORDER BY age ASC')
date = Date.today
result = statement.execute(date.strftime('2011-%m-%d'))

weeks = %w[月 火 水 木 金 土 日]
toottext = "今日は#{date.strftime('%Y年%m月%d日')}#{weeks[date.strftime('%u').to_i - 1]}曜日です"

if result.count > 0
  result.each do |row|
    toottext << "\n#{row['name']}さん(#{row['type']} #{row['age_s']}歳)"
  end
  toottext << "\n以上#{result.count}名のお誕生日です"
else
  toottext << "\n本日お誕生日を迎えたアイドルはいないようです"
end

puts '======  OUTPUT  ======='
puts toottext
puts '======================='

client.create_status(toottext.to_str)
