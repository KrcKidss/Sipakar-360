document.addEventListener('DOMContentLoaded', function(){
  document.body.classList.add('js-ready');

  var evalSelect = document.querySelector('select[name="evaluatee_id"]');
  var typeSelect = document.querySelector('select[name="assessment_type"]');
  if(evalSelect && typeSelect){
    function syncType(){
      var opt = evalSelect.options[evalSelect.selectedIndex];
      if(opt && opt.dataset.type){ typeSelect.value = opt.dataset.type; }
    }
    evalSelect.addEventListener('change', syncType);
    syncType();
  }

  document.querySelectorAll('.bar i').forEach(function(bar){
    var width = bar.style.width;
    if(!width) return;
    bar.style.width = '0%';
    requestAnimationFrame(function(){
      requestAnimationFrame(function(){ bar.style.width = width; });
    });
  });

  document.querySelectorAll('.btn').forEach(function(btn){
    btn.addEventListener('pointerup', function(){ btn.blur(); });
  });
});
