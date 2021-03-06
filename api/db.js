import pg from 'pg'
var Pool = require('pg').Pool;

// create a config to configure both pooling behavior
// and client options
// note: all config is optional and the environment variables
// will be read if the config is not present
var config = {
  user: process.env.RDS_USERNAME || 'postgres', //env var: PGUSER
  database: process.env.RDS_DB_NAME || 'postgres', //env var: PGDATABASE
  password: process.env.RDS_PASSWORD || 'admin', //env var: PGPASSWORD
  host: process.env.RDS_HOSTNAME || 'localhost', // Server hosting the postgres database
  port: process.env.RDS_PORT || 5432, //env var: PGPORT
  max: 10, // max number of clients in the pool
  idleTimeoutMillis: 30000, // how long a client is allowed to remain idle before being closed
};

// create the pool somewhere globally so its lifetime
// lasts for as long as your app is running
var pool = new Pool(config)

pool.on('error', function (err, client) {
  // if an error is encountered by a client while it sits idle in the pool
  // the pool itself will emit an error event with both the error and
  // the client which emitted the original error
  // this is a rare occurrence but can happen if there is a network partition
  // between your application and the database, the database restarts, etc.
  // and so you might want to handle it and at least log it out
  console.error('idle client error', err.message, err.stack);
});

//export the query method for passing queries to the pool
module.exports.query = function (text, values) {
  console.log('query:', text, values);
  return new Promise(function(resolve, reject) {
      pool.query(text, values, function(err, res) {
        try{
          if(err) {
              console.error('error running query', err);
              reject(err);
          }
          resolve(res.rows);
        }
        catch(e){
          console.log('error', e, 'at', err);
          reject(err);
        }
      });
  });
};

//export the query method for passing queries to the pool
module.exports.query_wrapped = function (text, values) {
  console.log('query:', text, values);
  return new Promise(function(resolve, reject) {
      pool.query(text, values, function(err, res) {
          if(err) {
              console.error('error running query', err);
              reject(err);
          }
          resolve(res);
      });
  });
};

//export the query method for passing queries to the pool
module.exports.raw_query = function (text, values, callback) {
  console.log('query:', text, values);
  return pool.query(text, values, callback);
};


// the pool also supports checking out a client for
// multiple operations, such as a transaction
module.exports.connect = function (callback) {
  return pool.connect(callback);
};