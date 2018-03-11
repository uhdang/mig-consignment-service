build:
	protoc -I. --go_out=plugins=micro:. \
		proto/consignment/consignment.proto
	docker build -t mig-consignment-service .

run:
	docker run -d --net="host" \
		--name mig-consignment-service \
		-p 50052 \
		-e MICRO_SERVER_ADDRESS=:50052 \
		-e MICRO_REGISTRY=mdns \
		-e DISABLE_AUTH=true \
		mig-consignment-service

runmongodb:
	docker run -d -p 27017:27017 --name mig-mongodb mongo

createconsignment:
	curl -XPOST -H 'Content-Type: application/json' -d '{ "service": "mig.consignment", "method": "ConsignmentService.Create", "request": { "description": "This is a test", "weight": 500, "containers": [] }}' --url http://localhost:8080/rpc
