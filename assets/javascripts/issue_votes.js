$(function() {

  if (('#table-votes').length) {
    $('#table-votes').DataTable({
      paging: false,
      scrollY: 350
      //    autoWidth: true,
    });

    $('#table-votes-org').DataTable({
      paging: false,
      scrollY: 200,
      aoColumns: [
        {sWidth: '100px'},
        {sWidth: '50px'},
      ]
    });
  }

  if (('#table-voting-organizations').length) {
    $('#table-voting-organizations').DataTable({
      paging: false,
      scrollY: 350
      //    autoWidth: true,
    });
  }

});