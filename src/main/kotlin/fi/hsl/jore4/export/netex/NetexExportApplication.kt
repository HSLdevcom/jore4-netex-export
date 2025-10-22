package fi.hsl.jore4.export.netex

import fi.hsl.jore4.export.netex.config.DatabaseProperties
import fi.hsl.jore4.export.netex.config.JOOQProperties
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Primary
import tools.jackson.databind.ObjectMapper
import tools.jackson.databind.json.JsonMapper
import tools.jackson.module.kotlin.KotlinFeature
import tools.jackson.module.kotlin.KotlinModule

fun main(args: Array<String>) {
    runApplication<NetexExportApplication>(*args)
}

@SpringBootApplication
@EnableConfigurationProperties(DatabaseProperties::class, JOOQProperties::class)
class NetexExportApplication {
    @Bean
    @Primary
    fun objectMapper(): ObjectMapper =
        JsonMapper
            .builder()
            .addModule(
                KotlinModule
                    .Builder()
                    .withReflectionCacheSize(512)
                    .configure(KotlinFeature.NullToEmptyCollection, false)
                    .configure(KotlinFeature.NullToEmptyMap, false)
                    .configure(KotlinFeature.NullIsSameAsDefault, false)
                    .configure(KotlinFeature.SingletonSupport, false)
                    .configure(KotlinFeature.StrictNullChecks, true)
                    .build(),
            ).build()
}
