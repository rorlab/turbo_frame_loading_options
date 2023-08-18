# Turbo Frames: Eager vs Lazy Loading

레일스 7 프로젝트에서는 디폴트 프론트엔드 프레임워크로 `hotwire`를 사용합니다. 

핫와이어의 터보 프레임 기능에는 두가지 로딩 옵션이 있습니다. 

첫번째는 `eager` 로딩(`즉시로딩`)인데, 터보 프레임 태그 안에 `src` 속성을 추가하고 `URL`을 지정하면 디폴트로 `eager` 로딩을 사용할 수 있습니다. 

두번째는 `lazy` 로딩(`지연로딩`)인데, 터보 프레임 태그 안에 `src` 와 함께 `loading `속성을 추가하고 `lazy `값을 지정하면 `lazy `로딩을 사용할 수 있게 됩니다.

`eager` 로딩이란 페이지가 로딩될 때 즉시 로딩된다는 뜻이고, `lazy` 로딩이란 페이지가 로딩된 후 브라우저의 뷰 포트에 보이게 될 때 비로소 로딩된다는 뜻입니다. 



이해를 돕기 위해서 실제로 프로젝트를 생성해서 설명 하겠습니다. 

터미널을 열고 turbo-frame 이라는 프로젝트를 생성하고 디렉토리 이동을 하겠습니다. 

```bash
rails new turbo-frame && cd turbo-frame
```

bin/setup 명령을 실행하고

```bash
bin/setup
```

Post 모델을 scaffolding 하겠습니다.

```bash
bin/rails g scaffold Post title:string content:text
```

방금 생성된 posts 테이블 생성을 위한 마이그레이션 파일에 대해서 bin/rails db:migrate 명령을 실행하겠습니다. 

```bash
bin/rails db:migrate
```

config/routes.rb 파일을 열고 root 경로를 추가하겠습니다. 

```ruby
root "posts#index"
```

db/seed.rb 파일을 열고 posts 테이블에 추가할 데이터를 작성합니다. 

```ruby
Post.create title: 'Sollicitudin Nullam Fermentum', content: 'Donec sed odio dui. Nullam id dolor id nibh ultricies vehicula ut id elit.'
Post.create title: 'Sit Adipiscing Nullam', content: 'Nullam id dolor id nibh ultricies vehicula ut id elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
Post.create title: 'Venenatis Tristique Mattis', content: 'Aenean lacinia bibendum nulla sed consectetur. Vestibulum id ligula porta felis euismod semper.'
Post.create title: 'Ligula Porta Risus', content: 'Etiam porta sem malesuada magna mollis euismod. Vestibulum id ligula porta felis euismod semper.'
Post.create title: 'Dolor Justo Cras', content: 'Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.'
```

posts 테이블에 방금 작성한 데이터를 추가하기 위해서 rails db:seed 명령을 실행합니다.

```bash
bin/rails db:seed
```

이제 로컬 웹서버를 실행한 후,

```bash
bin/rails server
```

크롬 브라우저에서 localhost:3000 으로 이동합니다.

브라우저 화면에 posts 데이터가 스크롤 되어 보이도록 `⌘` + `+` 키를 5번 눌러서 화면을 확대합니다.

views/posts/index.html.erb 파일을 열고, 아래의 코드라인을 추가합니다. 

```erb
<%= turbo_frame_tag "balloon-image", src: balloon_path do %>
  <div>
    <div>eager-loading</div>
    <%= image_tag "loading.webp", size: '30' %>
  </div>
<% end %>

<%= turbo_frame_tag "balloon-image", src: balloon_path, loading: 'lazy' do %>
  <div>
    <div>lazy-loading</div>
    <%= image_tag "loading.webp", size: '30' %>
  </div>
<% end %>
```

app/controllers/posts_controller.rb 파일을 열고 balloon 메소드를 추가합니다. 

```ruby
def ballon; end
```

다음은 app/views/posts/ 디렉토리에 balloon.html.erb 파일을 생성하고 아래의 코드라인을 추가합니다.

```erb
<%= turbo_frame_tag "balloon-image" do %>
  <%= image_tag "800px-Big_&_Small_Pumkins.jpg", width: '100' %>
<% end %>
```

config/routes.rb 파일을 열고 balloon 경로를 추가합니다. 

```ruby
  get "balloon", to: "posts#balloon", as: :balloon
```

그리고 아래의 링크에서 로딩 이미지와 테스트용 사진 이미지를 다운로드 받아 app/assets/images/ 디렉토리에 둡니다.

> 로딩 이미지 : https://i.gifer.com/ZZ5H.gif
> 풍선 이미지 : https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Big_%26_Small_Pumkins.JPG/800px-Big_%26_Small_Pumkins.JPG

지금까지 작업했던 내용을 브라우저에서 확인해 보겠습니다. 

크롬 브라우저에서 `⌘` + `⌥` + `I` 키를 눌러 inspector 를 열고 `Network` 탭을 클릭합니다. Network condition을 `No throttling` 에서 `Slow 3G` 로 변경합니다.

이제 브라우저에서  `⇧`+`⌘`+`R` 키를 눌러 페이지를 reloading 합니다.

Inspector 창의 Network 탭에서 ballon 이 하나만 표시되어 있는 것을 확인할 수 있습니다. 

이제 화면을 이미지가 보일 때까지 아래로 스크롤하면 풍선 이미지 하나가 보이고 그 아래에 Lazy loading 메시지가 보이면서 또 다른 풍선 이미지가 로딩되는 것을 확인할 수 있습니다. 

Inspector 창의 Network 탭에서 balloon 요청이 추가된 것을 확인할 수 있습니다.  

첫번째 풍선 이미지는 페이지가 로딩될 때 즉시 로딩이 되었던 것이고 두번째 풍선 이미지는 페이지를 스크롤하여 뷰포트에 보이게 될 때 로딩이 시작되는  것입니다. 그래서 lazy 로딩이라는 명칭을 사용하게 된 것입니다.

지금까지 hotwire 터보 프레임의 loading 옵션에 대해서 함께 알아 보았습니다. 

감사합니다.

