// add nickname

// Vote user
$('body').on('click', '#voting_button', function () {
  var form = $('#form_voting'),
      form_voting = form.serialize();
  // check command
  if (form_voting && (form[0][0].checked || form[0][1].checked)  && form[0][2].value && form[0][3].value) {
    $.ajax({
      method: "POST",
      url: "vote.php",
      data: form_voting
    }).done(function (res) {
      var voting_act = $('#voting_act'),
        result_success = '',
        result_error = '',
        myModalError = new bootstrap.Modal(document.getElementById('Modal_error'), {
        keyboard: false
      });

      switch (LANG) {
        case "ru":
          result_success = 'Голос засчитан';
          result_error = 'Ошибка';
          break;
        case "de":
          result_success = 'Auswahl wurde bestätigt';
          result_error = 'ein Fehler';
          break;
        case "pl":
          result_success = 'Wybór potwierdzony';
          result_error = 'błąd';
          break;
        case "en":
        default:
          result_success = 'Choice confirmed';
          result_error = 'Error';
          break;
      }

      if (res) {
        // не разрешаем выбирать команды в голосовании
        $("input[type=radio]").attr('disabled', true);
        // удаляем кнопку потвердить и добавляем текст
        voting_act.children('button').remove();
        voting_act.append('<span class="text-green-light p-2 credited">' + result_success + '</span>');
      } else {
        myModalError.show();
      }
    });
  }

});

// button up
$(window).scroll(function () {
  if ($(this).scrollTop() > 100) {
    if ($('#upbutton').is(':hidden')) {
      $('#upbutton').css({opacity: 1}).fadeIn('slow');
    }
  } else {
    $('#upbutton').stop(true, false).fadeOut('fast');
  }
});
$('#upbutton').click(function () {
  $('html, body').stop().animate({scrollTop: 0}, 300);
});
