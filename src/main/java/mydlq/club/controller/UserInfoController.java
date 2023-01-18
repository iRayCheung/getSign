package mydlq.club.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import mydlq.club.config.SystemConfig;
import mydlq.club.entity.SignAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户信息 Controller
 */
@Api(tags = "签名配置管理")
@RestController("/")
@RequestMapping
public class UserInfoController {

    @Autowired
    SystemConfig systemConfig;

    @PostMapping("/getSign")
    @ApiOperation("获取签名")
    public String getUserInfo(@RequestBody SignAO signAO) {
        List<String> whitelist = systemConfig.getWhitelist();
        return signAO.getData();
    }

}
