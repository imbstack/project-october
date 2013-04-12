var OctoberHomepage = (function($) {
  var $articles = $("#articles .row"),
    prevWidth = 0,
    masonryEnabled = false;

  var init = function(query) {
    $(window).resize(updateHomepageHandler);
    $articles.on("ajax:success", orangifyUpvoteDownvote);
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

    $onboarder = $articles.find("#onboard_terms");
    if ($onboarder.length > 0) {
      $onboarder.tagit({ fieldName: 'tags[]' });
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
  }

  var updateImages = function() {
    width = $articles.find(".article.square").width();

    $articles.find(".article.square img").each(function(i) {
      $this = $(this);
      imgWidth = $this.is(".img-secondary") ? 0.45 * width : width;

      $this.css({
        width: imgWidth,
        height: imgWidth * $this.data('ratio')
      });
    });
  }

  var orangifyUpvoteDownvote = function(data, status, xhr) {
    $target = $(data.target);
    $target.parents("ul").find("a").removeClass("voted");
    $target.addClass("voted");
  }

  return {
    init : init,
  };
}($));
