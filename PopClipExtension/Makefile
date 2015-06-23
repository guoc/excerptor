bundle_name=excerptor.popclipext

excerptor.popclipextz : Config.plist
	mkdir ./$(bundle_name)
	cp $^ ./$(bundle_name)/
	zip -rm $@ ./$(bundle_name)

.PHONY: clean
clean:
	rm excerptor.popclipextz 
