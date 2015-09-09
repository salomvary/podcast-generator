update-example:
	git rm -rf example
	mkdir -p example
	cd example; ../generate-podcast.sh
	git add example
	git commit -m 'Update example'
	git push
