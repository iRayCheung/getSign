package controller;

import mydlq.club.GetSignApplication;
import mydlq.club.config.SystemConfig;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.List;

/**
 * @Description:
 * @Author: Ray Cheung
 * @create: 12/8/2022 9:51 AM
 */
@ActiveProfiles("local")
@RunWith(SpringRunner.class)
@SpringBootTest(classes = GetSignApplication.class, webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class ControllerTest {

    @Autowired
    SystemConfig systemConfig;


    @Test
    public void getEngineMesData() {
        List<String> whitelist = systemConfig.getWhitelist();
        System.out.println("1");
        int a = 1/0;
    }


}
