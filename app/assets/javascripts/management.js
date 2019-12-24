$(function () {
  $(document).on('turbolinks:load', function (e) {
    $(".ec2-action-btn").on('click', function (e) {
      e.preventDefault();
      let url = e.currentTarget.href;
      let formData = new FormData($(e.currentTarget).closest('form').get(0));
      formData.append('instance_id', $(e.currentTarget).data('instanceId'));
      let origin_btn_text = e.currentTarget.text;

      // debugger
      //動かす処理ローディング
      e.currentTarget.text = '実行中...';
      $(e.currentTarget).addClass('disabled');
      $(e.currentTarget).siblings().addClass('disabled');

      $.ajax({
        url: url,
        type: "post",
        data: formData,
        processData: false,
        contentType: false
      })
        .done(function (data, textStatus, jqXHR) {
          e.currentTarget.text = origin_btn_text;
          let state = $(e.currentTarget).parent()
            .parent()
            .siblings('.main__content__item__header')
            .find('.main__content__item__header__state')
            .get(0);

          if ($(e.currentTarget).hasClass('ec2-restart-btn')) {
            let start_btn = $(e.currentTarget).siblings('.ec2-start-btn').get(0);
            let stop_btn = $(e.currentTarget).siblings('.ec2-stop-btn').get(0);
            $(start_btn).removeClass('btn-success active').addClass('btn-secondary disabled');
            $(stop_btn).removeClass('btn-secondary disabled').addClass('btn-warning active');
            $(e.currentTarget).removeClass('btn-secondary disabled').addClass('btn-primary active');
            $(state).removeClass('main__content__item__header__state--down').addClass('main__content__item__header__state--up');
          }
          else {
            $(e.currentTarget).removeClass('btn-success btn-warning active').addClass('btn-secondary disabled');
            $(e.currentTarget).siblings().removeClass('btn-secondary disabled');

            if ($(e.currentTarget).hasClass('ec2-start-btn')) {
              let stop_btn = $(e.currentTarget).siblings('.ec2-stop-btn').get(0);
              $(stop_btn).addClass('btn-warning active');
              $(state).removeClass('main__content__item__header__state--down').addClass('main__content__item__header__state--up');
            }
            else {
              let start_btn = $(e.currentTarget).siblings('.ec2-start-btn').get(0);
              $(start_btn).addClass('btn-success active');
              $(state).removeClass('main__content__item__header__state--up').addClass('main__content__item__header__state--down');
            }

            let restart_btn = $(e.currentTarget).siblings('.ec2-restart-btn').get(0)
            $(restart_btn).addClass('btn-primary active');
          }
          console.log(data)
        })
        .fail(function () {
          e.currentTarget.text = origin_btn_text;
          alert(`EC2インスタンスの${origin_btn_text}に失敗しました`);
        });
    })

  });

})