// Mobile nav toggle
document.addEventListener('DOMContentLoaded',function(){
  const nav = document.getElementById('site-nav');
  const btn = document.getElementById('nav-toggle');
  if(btn && nav){
    btn.addEventListener('click',()=>{
      const shown = nav.style.display === 'flex';
      nav.style.display = shown ? '' : 'flex';
      if(!shown){nav.style.flexDirection='column';nav.style.gap='12px'}
    });
    // close when link clicked (mobile)
    nav.querySelectorAll('a').forEach(a=>a.addEventListener('click',()=>{if(window.innerWidth<=640){nav.style.display=''}}))
  }

  // smooth scroll for internal links
  document.querySelectorAll('a[href^="#"]').forEach(anchor=>{
    anchor.addEventListener('click',function(e){
      const href = this.getAttribute('href');
      if(href.length>1){
        e.preventDefault();
        const el = document.querySelector(href);
        if(el) el.scrollIntoView({behavior:'smooth',block:'start'});
      }
    });
  });

  // contact form basic handler
  const form = document.getElementById('contact-form');
  if(form){
    form.addEventListener('submit',function(e){
      e.preventDefault();
      // collect values (in real site you'd send to server)
      const data = new FormData(form);
      alert('감사합니다! 메시지를 보냈습니다.\n' + data.get('name') + ' — ' + data.get('email'));
      form.reset();
    });
  }
});
