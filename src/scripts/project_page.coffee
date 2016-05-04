# # # # # # # # # # # # # # #
# # # PROJECTS PAGE # # # # #
# # # # # # # # # # # # # # #

resize_videos = (selector) ->
	selector ?= '.contents .youtube iframe, .contents .vimeo iframe'
	$(selector).each (i, video) ->
		width = $(video).width()
		height = width / 1.6
		$(video).height(height)	
		$(video).parent().height(height + 1)

resize_embeds = (selector) ->
	selector ?= '.contents .embed iframe, .contents .embed video'
	$(selector).each (i, embed) ->
		spec_width = $(embed).attr('width')
		spec_height = $(embed).attr('height')

		# If the element scales according to a ratio
		if spec_width
			# If the element has a pixel ratio specified in terms of width and height
			if spec_width != '100%'
				# Read spec ratio
				ratio = spec_width / spec_height
				# Calculate new height from ratio
				width = $(embed).width()
				height = width * ratio
				# Resize embed
				$(embed).height(height)
			# else, the element stretches to 100% width
			else
				# Just ensure the desired height is remembered
				height = $(embed).height()
		# else, the element scales automatically
		else 
				# We might have a height by this time
				height = $(embed).height()

		# If we succeeded in obtaining a height
		if height != NaN
			# Ensure the parent doesn't leave a bottom gap
			$(embed).parent().height(height)

		# # If we're dealing with a video and we're iterating over a larger collection of items
		# if embed.tagName == 'VIDEO' and !selector.tagName
		# 	# Listen for metadata
		# 	$(embed).on 'loadedmetadata', ->
		# 		console.log('loaded metadata')
		# 		# Resize the embed
		# 		resize_embeds(embed)
		# 		# and stop listening for changes
		# 		$(embed).off 'loadedmetadata'
		
annotate_paragraphs = ->
	$('.contents p').each (i, p) ->
		if $(p).find('img').length == 0 and $(p).hasClass('imgix-fluid') == false
			$(p).addClass('no-img')
		if $(p).find('video').length > 0 or $(p).find('embed').length > 0
			$(p).addClass('no-img') unless $(p).hasClass('no=img')
			
style_content = ->
	annotate_paragraphs()
	resize_videos()
	resize_embeds()
	$(window).resize ->
		resize_videos()
		resize_embeds()

module.exports = ->
	if $('body').hasClass('project')
		style_content()