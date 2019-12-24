$(function () {

  $(document).on('turbolinks:load', function (e) {

    $(".ec2-action-btn").on('click', function (event) {
      event.preventDefault();
      let url = event.currentTarget.href;
      let formData = new FormData($(event.currentTarget).closest('form').get(0));
      formData.append('instance_id', $(event.currentTarget).data('instanceId'));
      let origin_btn_text = event.currentTarget.text;

      // debugger
      //動かす処理ローディング
      event.currentTarget.text = '実行中...';
      $(event.currentTarget).addClass('disabled');
      $(event.currentTarget).siblings().addClass('disabled');

      $.ajax({
        url: url,
        type: "post",
        beforeSend: function (xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')) },
        data: formData,
        processData: false,
        contentType: false
      })
        .done(function (data, textStatus, jqXHR) {
          event.currentTarget.text = origin_btn_text;
          let state = $(event.currentTarget).parent()
            .parent()
            .siblings('.main__content__item__header')
            .find('.main__content__item__header__state')
            .get(0);

          if ($(event.currentTarget).hasClass('ec2-restart-btn')) {
            let start_btn = $(event.currentTarget).siblings('.ec2-start-btn').get(0);
            let stop_btn = $(event.currentTarget).siblings('.ec2-stop-btn').get(0);
            $(start_btn).removeClass('btn-success active').addClass('btn-secondary disabled');
            $(stop_btn).removeClass('btn-secondary disabled').addClass('btn-warning active');
            $(event.currentTarget).removeClass('btn-secondary disabled').addClass('btn-primary active');
            $(state).removeClass('main__content__item__header__state--down').addClass('main__content__item__header__state--up');
          }
          else {
            $(event.currentTarget).removeClass('btn-success btn-warning active').addClass('btn-secondary disabled');
            $(event.currentTarget).siblings().removeClass('btn-secondary disabled');

            if ($(event.currentTarget).hasClass('ec2-start-btn')) {
              let stop_btn = $(event.currentTarget).siblings('.ec2-stop-btn').get(0);
              $(stop_btn).addClass('btn-warning active');
              $(state).removeClass('main__content__item__header__state--down').addClass('main__content__item__header__state--up');
            }
            else {
              let start_btn = $(event.currentTarget).siblings('.ec2-start-btn').get(0);
              $(start_btn).addClass('btn-success active');
              $(state).removeClass('main__content__item__header__state--up').addClass('main__content__item__header__state--down');
            }

            let restart_btn = $(event.currentTarget).siblings('.ec2-restart-btn').get(0)
            $(restart_btn).addClass('btn-primary active');
          }
        })
        .fail(function () {
          event.currentTarget.text = origin_btn_text;
          alert(`EC2インスタンスの${origin_btn_text}に失敗しました`);
        });
    });

  });

});