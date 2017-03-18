const config = {
    "dialect": "sqlite",
    "storage": "./db.sqlite"
};

const Sequelize = require('sequelize');
const sequelize = new Sequelize(null, null, null, config);

const User = sequelize.define('user', {
  name  : Sequelize.STRING,
  email : Sequelize.STRING
});

function init() {
  sequelize.sync()
//  .then(function() {
//    return User.create({
//      name  : 'Sviat',
//      email : 'svchumakov@gmail.com'
//    });
//  });
//  }).then(function(user) {
//    console.log(user.get({
//      plain: true
//    }));
//  });
}

module.exports = {
  User, init
};
