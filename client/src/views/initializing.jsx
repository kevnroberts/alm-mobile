/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
  		ReactView = require('views/base/react_view'),
  		Spinner = require('spin');

  return ReactView.createChaplinClass({
    render: function() {
    	return <div className="jumbotron"><p className="text-center">Initializing...</p></div>;
    },
    componentDidMount: function() {
      $(this.getDOMNode()).find('p').append(new Spinner().spin().el);
    },
    componentWillUnmount: function() {
      $(this.getDOMNode()).find('.spinner').remove();
    }
  });
});