package mydlq.club.config;

import io.swagger.annotations.ApiOperation;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RestController;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.*;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spi.service.contexts.SecurityContext;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @Description :
 * @Author : RayCheung
 * @create 1/16/2023 3:47 PM
 */
@Configuration
@EnableSwagger2
public class SwaggerConfig {

    /**
     * swagger2的配置文件，这里可以配置swagger2的一些基本的内容，比如扫描的包等等
     *
     * @return Docket
     */
    @Bean(value = "defaultApi2")
    public Docket defaultApi2() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                // 此包路径下的类，才生成接口文档
                .apis(RequestHandlerSelectors.basePackage("mydlq.club.controller"))
                // 加了ApiOperation注解的类，才生成接口文档
                .apis(RequestHandlerSelectors.withClassAnnotation(RestController.class))
                .apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))
                .paths(PathSelectors.any())
                .build()
                .securitySchemes(securityScheme())
//                .securityContexts(securityContexts())
                ;
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("GetSign测试项目")
                .description("GetSign测试项目-API接口文档")
                .contact(new Contact("RayPick Team", null, "xxxxxxx@qq.com"))
                .version("1.0.0").build();
    }

    /***
     * oauth2配置，需要增加swagger授权回调地址
     *
     * @return SecurityScheme
     */
    @Bean
    List<SecurityScheme> securityScheme() {
        List<SecurityScheme> securitySchemes = new ArrayList<>();
        securitySchemes.add(new ApiKey("token", "token", "header"));
        securitySchemes.add(new ApiKey("X-APP-SYSTEM", "X-APP-SYSTEM", "header"));
        return securitySchemes;
    }

    /**
     * 新增 securityContexts 保持登录状态
     *
     * @return List<SecurityContext>
     */
    private List<SecurityContext> securityContexts() {
        return new ArrayList(
                Collections.singleton(SecurityContext.builder()
                        .securityReferences(defaultAuth())
                        .forPaths(PathSelectors.regex("^(?!auth).*$"))
                        .build())
        );
    }

    private List<SecurityReference> defaultAuth() {
        AuthorizationScope authorizationScope = new AuthorizationScope("global", "accessEverything");
        AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
        authorizationScopes[0] = authorizationScope;
        return new ArrayList(Collections.singleton(new SecurityReference("token", authorizationScopes)));
    }

}
