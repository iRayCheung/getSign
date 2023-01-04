package mydlq.club.example.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 用户信息 Controller
 */
@RestController
@RequestMapping
public class UserInfoController {


    @GetMapping("/getSign")
    public String getUserInfo() {
        return "sign success3";
    }

}
