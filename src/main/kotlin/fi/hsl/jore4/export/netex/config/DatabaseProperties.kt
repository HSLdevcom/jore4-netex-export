package fi.hsl.jore4.export.netex.config

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "jore4.db")
data class DatabaseProperties(
    val driver: String,
    val url: String,
    val username: String,
    val password: String,
    val minConnections: Int,
    val maxConnections: Int,
)
