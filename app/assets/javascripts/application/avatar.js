$(function () {
  $('#avatar-js').on("change", () => {
    $('#dialog').modal({
      show: true
    });

    preview_image_modal();

    const panel = $('#crop_panel');
    let m_pos;
    let x_axis = true;

    //add a listener to the document depending on where you tap in the box
    panel.on("pointerdown", function(e) {
      const BORDER_SIZE = 20;

      if (e.offsetY >= (parseInt(panel.css('height')) - BORDER_SIZE)) {
        m_pos = e.y;
        x_axis = false;
        document.addEventListener("pointermove", resize, false);
      } else if (e.offsetX >= (parseInt(panel.css('width')) - BORDER_SIZE)) {
        m_pos = e.x;
        x_axis = true;
        document.addEventListener("pointermove", resize, false);
      } else {
        pos3 = e.clientX;
        pos4 = e.clientY;
        document.addEventListener("pointermove", drag, false);
      }
    });

    // remove listeners from the document when you stop pressing
    document.addEventListener("pointerup", function () {
      document.removeEventListener("pointermove", resize, false);
      document.removeEventListener("pointermove", drag, false);
      document.removeEventListener("pointermove", resize, false);
    }, false);

    // on submit take the parameters of the box to crop the avatar
    $('#form_photo').on("submit", () => {
      let total_width = parseInt(getComputedStyle(document.getElementById("containerCrop")).width);
      let photo_width = parseInt(getComputedStyle(document.getElementById("foto")).width);
      let left_displacement = total_width - photo_width;

      $('#height_offset').val(parseInt(panel.css('top')) - 15);
      $('#width_offset').val(parseInt(panel.css('left'))  - 15 - (left_displacement/2));
      $('#height_width').val(parseInt(panel.css('width')));
      $('#original_width').val($('#foto').width());
    });

    function resize(e) {
      e = e || window.event;
      e.preventDefault();

      let mov = x_axis ? e.x : e.y;
      const dx = m_pos - mov;
      m_pos = mov;

      if (can_change(panel, dx, false)) {
        panel.width(panel.width() - dx);
        panel.height(panel.width() - dx);
      }
    }

    function drag(e) {
      e = e || window.event;
      e.preventDefault();

      pos1 = pos3 - e.x;
      pos2 = pos4 - e.y;
      pos3 = e.x;
      pos4 = e.y;

      if (can_change(panel, pos1 + pos2, true)) {
        panel.offset({ top: (panel.offset().top - pos2) , left: (panel.offset().left - pos1)});
      }
    }

    function can_change(el, mov, dragging) {
      let canChange = true;
      let pos = dragging ? [el.css('top'), el.css('left'), el.css('bottom'), el.css('right')] : [el.css('bottom'), el.css('right')];

      pos.forEach((el, ix) => {
        let next = dragging && (ix == 0 || ix == 1) ? parseInt(el) -  mov : parseInt(el) +  mov;
        if( next < 14 ) {
          canChange = false;
        }
      });

      return canChange;
    }

    function preview_image_modal() {
      var preview = document.querySelector('#foto');
      var file = document.querySelector('#avatar-js').files[0];
      var reader = new FileReader();

      reader.onloadend = function () {
        preview.src = reader.result;
      }

      if (file) {
        reader.readAsDataURL(file);
      } else {
        preview.src = "";
      }
    }
  });
});
