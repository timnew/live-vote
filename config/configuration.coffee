process.env.NODE_ENV = process.env.NODE_ENV?.toLowerCase() ? 'development'

class Config
  port: 80
  cookieSecret: '!J@IOH$!BFBEI#KLjfelajf792fjdksi23989HKHD&&#^@'

class Config.development extends Config
  port: 3000

class Config.test extends Config

class Config.production extends Config

module.exports = new Config[process.env.NODE_ENV]()