package fi.hsl.jore4.export.netex

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication


fun main(args: Array<String>) {
    runApplication<NetexExportApplication>(*args)
}

@SpringBootApplication
class NetexExportApplication {

}