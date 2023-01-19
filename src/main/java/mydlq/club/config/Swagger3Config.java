package mydlq.club.config;//package mydlq.club.config;
//
//import io.swagger.annotations.ApiOperation;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.context.annotation.Import;
//import org.springframework.web.bind.annotation.RestController;
//import springfox.bean.validators.configuration.BeanValidatorPluginsConfiguration;
//import springfox.documentation.builders.ApiInfoBuilder;
//import springfox.documentation.builders.PathSelectors;
//import springfox.documentation.builders.RequestHandlerSelectors;
//import springfox.documentation.service.*;
//import springfox.documentation.spi.DocumentationType;
//import springfox.documentation.spi.service.contexts.SecurityContext;
//import springfox.documentation.spring.web.plugins.Docket;
//import springfox.documentation.swagger2.annotations.EnableSwagger2WebMvc;
//
//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.List;
//
//@Configuration
//@EnableSwagger2WebMvc
//@Import(BeanValidatorPluginsConfiguration.class)
//public class Swagger2Config {
//
//    @Bean
//    public Docket createRestApi() {
//
//        return new Docket(DocumentationType.SWAGGER_2)
//                .apiInfo(apiInfo())
//                //是否开启
//                .select()
//                //设置basePackage会将包下的所有被@Api标记类的所有方法作为api
//                .apis(RequestHandlerSelectors.basePackage("mydlq.club.controller"))
//                // 加了ApiOperation注解的类，才生成接口文档
//                .apis(RequestHandlerSelectors.withClassAnnotation(RestController.class))
//                .apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))
//                //指定路径处理PathSelectors.any()代表所有的路径
//                .paths(PathSelectors.any())
//                .build()
//                .securitySchemes(securityScheme())
////                .securityContexts(securityContexts())
//                ;
//    }
//
//    private ApiInfo apiInfo() {
//        return new ApiInfoBuilder()
//                // 文档标题
//                .title("GetSign测试项目")
//                //文档描述
//                .description("GetSign测试项目-API接口文档")
//                .contact(new Contact("RayPick Team", null, "xxxxxxx@qq.com"))
//                //版本号
//                .version("1.0.0")
//                .build();
//    }
//
//
//    /***
//     * oauth2配置，需要增加swagger授权回调地址
//     *
//     * @return SecurityScheme
//     */
//    @Bean
//    List<SecurityScheme> securityScheme() {
//        List<SecurityScheme> securitySchemes = new ArrayList<>();
//        securitySchemes.add(new ApiKey("token", "token", "header"));
//        securitySchemes.add(new ApiKey("X-APP-SYSTEM", "X-APP-SYSTEM", "header"));
//        return securitySchemes;
//    }
//
//    /**
//     * 新增 securityContexts 保持登录状态
//     *
//     * @return List<SecurityContext>
//     */
//    private List<SecurityContext> securityContexts() {
//        return new ArrayList(
//                Collections.singleton(SecurityContext.builder()
//                        .securityReferences(defaultAuth())
//                        .forPaths(PathSelectors.regex("^(?!auth).*$"))
//                        .build())
//        );
//    }
//
//    private List<SecurityReference> defaultAuth() {
//        AuthorizationScope authorizationScope = new AuthorizationScope("global", "accessEverything");
//        AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
//        authorizationScopes[0] = authorizationScope;
//        return new ArrayList(Collections.singleton(new SecurityReference("token", authorizationScopes)));
//    }
//
//}
