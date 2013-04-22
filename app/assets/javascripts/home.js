var OctoberHomepage = (function($) {
  var $articles = $("#articles .row"),
    prevWidth = 0,
    masonryEnabled = false,
    beginTime = 0;

  var init = function(query) {
    $(window).resize(updateHomepageHandler);
    $articles.on("ajax:success", orangifyUpvoteDownvote);
    beginTime = new Date().getTime();
    $.ajax('/posts/recommendations', {
      dataType: 'html',
      data: { 'search[query]' : query },
    }).done(receiveArticles);
  }

  var receiveArticles = function(data) {
    $articles.hide();
    $articles.html(data);
    $articles.fadeIn();
    updateHomepageHandler();

    mixpanel.track("Receive Recommendations", { ms: (new Date().getTime() - beginTime) });

    $onboarder = $articles.find("#onboard_terms");
    if ($onboarder.length > 0) {
      $onboarder.tagit({ fieldName: 'tags[]', allowSpaces: true});
    }
  }

  var updateHomepageHandler = function(ev) {
    force = !!ev && !!ev.force;

    var nowWidth = $articles.width();

    if (masonryEnabled && nowWidth == prevWidth && !force) { return; }
    if (nowWidth < 724) {
      if (masonryEnabled) {
        $articles.masonry('destroy');
        masonryEnabled = false;
      }

      return;
    }

    prevWidth = nowWidth;
    masonryEnabled = true;

    updateImages();

    $articles.masonry({
      itemSelector: '.article',
      columnWidth: nowWidth / 3,
    });
    mixpanel.track_links('.article h2 a', 'Click Article Headline')
  }

  var updateImages = function() {
    width = $articles.find(".article.square").width();

    $articles.find(".article.square img.article-image").each(function(i) {
      $this = $(this);
      imgWidth = $this.is(".img-secondary") ? 0.45 * width : width;

      $this.css({
        width: imgWidth,
        height: imgWidth * $this.data('ratio')
      });
    });
  }

  var orangifyUpvoteDownvote = function(data, status, xhr) {
    if (data.target.href.match('/upvote'))
      mixpanel.track("Vote", { direction: 'Up' });
    if (data.target.href.match('/downvote'))
      mixpanel.track("Vote", { direction: 'Down' });

    $target = $(data.target);
    $target.parents("ul").find("a").removeClass("voted");
    $target.addClass("voted");
  }

  return {
    init : init,
  };
}($));
