/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
  		ReactView = require('views/base/react_view');

  return ReactView.createChaplinClass({
    render: function() {
    	return (
        <div id="login">
          <div className="login-header">
            <div>
              <div className="labs-icon"/>
              <div className="slogan">Go Agile. Go Rally.</div>
            </div>
          </div>
          <form className="login-form" role="form" onSubmit={this.signIn}>
            <div className="form-group">
              <h2 className="control-label">LOGIN</h2>
            </div>
            <div className="alert alert-danger"/>
            <div className="form-group">
              <label className="control-label" htmlFor="username">Username</label>
              <div>
                <input className="form-control" type="text" id="username" placeholder="Username" defaultValue=""/>
              </div>
            </div>
            <div className="form-group">
              <label className="control-label" htmlFor="password">Password</label>
              <div>
                <input className="form-control" type="password" id="password" placeholder="Password" defaultValue=""/>
              </div>
            </div>
            <div className="form-group">
              <div className="control-label">
                <button type="submit" className="btn btn-lg btn-primary sign-in">Sign in</button>
              </div>
            </div>
            <div className="form-group copyright">
              <small>&copy; 2003-{new Date().getFullYear()} Rally Software Development Corp.</small>
            </div>
          </form>
        </div>
      );
    },

    componentDidMount: function() {
      $('body').addClass('login-body');
      if (window.loginError) {
        $('.alert').html(window.loginError).show();
        delete window.loginError;
      }
    },

    componentWillUnmount: function() {
      $('body').removeClass('login-body');
    },

    signIn: function(event) {
      $('.alert').hide();
      username = $('#username').val();
      password = $('#password').val();
      this.trigger('submit', username, password);
      event.preventDefault();
    },

    showError: function(error) {
      $('#password').html('');
      $('.alert').html(error).show();
    }
  });
});