package mydlq.club.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * @Description :
 * @Author : RayCheung
 * @create 1/16/2023 3:24 PM
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "system")
public class SystemConfig {

    private List<String> whitelist;

}
