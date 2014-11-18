  package MyLib::Controller;
  use Mojo::Base 'Mojolicious::Controller';

  sub render_exception{ 
    shift->render(json => {
      error => 'server error'
    }) 
  }

  sub render_not_found{ 
    shift->render(json => {
      error => 'not found'
    }) 
  }

  1; 