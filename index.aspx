<!doctype html>
<html lang="en">

	<head>
		<meta charset="utf-8">

		<title>Cypress Fundamentals</title>

		<link rel="stylesheet" href="./dist/reveal.css">
		<link rel="stylesheet" href="./dist/theme/white.css" id="theme">
		<link rel="stylesheet" href="./plugin/monokai.css">
	</head>

	<body>

		<div class="reveal">

			<div class="slides">

				<section data-markdown="markdown.md" 
									data-separator="^\n\n\n" 
									data-separator-vertical="^\n\n" 
									data-separator-notes="^Note:">
				</section>
			</div>
		</div>

		<script src="./dist/reveal.js"></script>
		<script src="./plugin/markdown.js"></script>
		<script src="./plugin/highlight.js"></script>

		<script>
			Reveal.initialize({
				controls: true,
				progress: true,
				history: true,
				center: true,
				slideNumber: 'c/t',
				plugins: [ RevealMarkdown, RevealHighlight, RevealNotes ]
			});
		</script>
	</body>
</html>
