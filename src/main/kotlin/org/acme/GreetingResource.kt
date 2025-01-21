package org.acme

import io.quarkus.example.Greeter
import io.quarkus.example.HelloWorldProto.HelloReply
import io.quarkus.example.HelloWorldProto.HelloRequest
import io.quarkus.grpc.GrpcClient
import io.smallrye.mutiny.Uni
import jakarta.ws.rs.GET
import jakarta.ws.rs.Path
import jakarta.ws.rs.Produces
import jakarta.ws.rs.core.MediaType


@Path("/hello")
class GreetingResource {

    @GrpcClient
    lateinit var hello:Greeter

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    fun hello(): String {
        return "hello"
    }

    @GET
    @Path("/{name}")
    fun hello(name: String?): Uni<String> {
        return hello.sayHello(HelloRequest.newBuilder().setName(name).build())
            .onItem().transform { helloReply: HelloReply -> helloReply.message }
    }
}
