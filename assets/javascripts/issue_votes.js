$(function() {

  if ('#table_votes') {
    $('#table_votes').DataTable({
      paging: false,
      scrollY: 350
      //    autoWidth: true,
    });

    $('#table_votes_org').DataTable({
      paging: false,
      scrollY: 200,
      aoColumns: [
        {sWidth: '100px'},
        {sWidth: '50px'},
      ]
    });
  }
});