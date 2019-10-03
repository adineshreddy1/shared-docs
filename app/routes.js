var lc = require('./controller.js');

module.exports = function(application){

  application.post('/Generatedocs', function(req, res){
    lc.Generatedocs(req, res);
  });
  application.post('/sharedocs', function(req, res){
    lc.sharedocs(req, res);
  });
  application.post('/GetAlldocs', function(req, res){
    lc.GetAlldocs(req, res);
  });
  application.get('/QueryName', function(req, res){
    lc.QueryName(req, res);
  });
 
}
