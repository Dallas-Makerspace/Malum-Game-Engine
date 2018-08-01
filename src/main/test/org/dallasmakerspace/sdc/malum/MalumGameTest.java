package org.dallasmakerspace.sdc.malum.tests;

import com.jme3.bounding.BoundingBox;
import com.jme3.collision.CollisionResults;
import com.jme3.math.ColorRGBA;
import com.jme3.math.Ray;
import com.jme3.math.Vector3f;
import com.jme3.scene.Geometry;
import com.jme3.system.AppSettings;
import com.jme3.system.JmeContext;
import junit.framework.Assert;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import org.dallasmakerspace.sdc.malum.MalumGame;


public class MainTest {
    public static Main app;//Our test target application or class.

    @BeforeClass
    public static void beforeRunTests() {
        app = new MalumGame();
        //Yeah, load the defaults...
        AppSettings settings = new AppSettings(true);
        //We are not going to use any input, that should be cover by our game 
        //testers they know how to do it, is their job :).
        settings.setUseInput(false);
        app.setSettings(settings);
        //This will run in our jenkins server so, no monitor, no display :).
        app.start(JmeContext.Type.Headless);
        //This method normally is called in the GL/Rendering thread so any 
        //GL-dependent resources can be initialized.
        //We don't have any display in our jenkins server so it is fine 
        //to calling manually here...
        app.initialize();
    }

    @AfterClass
    public static void afterRunTests() {
        //Typically cleanup of native resources should happen here. 
        //This method is called in the GL/Rendering thread.
        //We don't have any display in our jenkins server so calling manually...
        try {
            app.destroy();
        } catch (Exception e) {
            //Ignore any destroy exception. This tests are not running with a 
            //display, so anything can happend, in theory we are not testing 
            //the destroy() method, remenber this is the afterClass method run 
            //after all tests, so it is for cleaning purposes mainly.
            //You could log, print or whatever you want with the exception. 
            //I´m ignoring it on purpose. :)
        }
    }

    @Before
    public void beforeEachTest() {
        //Before each...
    }

    @After
    public void afterEachTest() {
        //After each...
    }

    /**
     * It shouldn´t be any obstacle between the box and the camera.
     */
    @Test
    public void shouldNotBeAnyObstacleBetweenBoxAndCamera() {
        Vector3f camDir = app.getCamera().getDirection();
        Assert.assertEquals(camDir, new Vector3f(0, 0, -1.0f));
        Ray ray = new Ray(app.getCamera().getLocation(), camDir);
        CollisionResults results = new CollisionResults();
        if (app.getRootNode().collideWith(ray, results) <= 0) {
            Assert.fail(
                    "Ray fired from " + app.getCamera().getLocation()
                    + " in the direction " + camDir
                    + " goes to infinity!");
        } else {
            Assert.assertEquals("Box",
                    results.getClosestCollision().getGeometry().getName());
        }
    }

    /**
     * It should be the box geometry name the expected one.
     */
    @Test
    public void shouldBeTheBoxGeometryNameTheExpectedOne() {
        Geometry geom = (Geometry) app.getRootNode().getChild("Box");
        Assert.assertNotNull(geom);
    }

    /**
     * It should have the box the expected color.
     */
    @Test
    public void shouldHaveTheBoxTheExpectedColor() {
        Geometry geom = (Geometry) app.getRootNode().getChild("Box");
        ColorRGBA color = (ColorRGBA) geom.getMaterial()
                .getParam("Color").getValue();
        Assert.assertEquals(ColorRGBA.Blue, color);
    }

    /**
     * It should have the box the expected length.
     */
    @Test
    public void shouldHaveTheBoxTheExpectedLength() {
        Geometry geom = (Geometry) app.getRootNode().getChild("Box");
        BoundingBox boundingBox = (BoundingBox) geom.getWorldBound();
        Assert.assertEquals("For box length",2.0f,boundingBox.getXExtent() * 2);
    }

    /**
     * It should have the box the expected height.
     */
    @Test
    public void shouldHaveTheBoxTheExpectedHeight() {
        Geometry geom = (Geometry) app.getRootNode().getChild("Box");
        BoundingBox boundingBox = (BoundingBox) geom.getWorldBound();
        Assert.assertEquals("For box height",2.0f,boundingBox.getYExtent() * 2);
    }

    /**
     * It should have the box the expected width.
     */
    @Test
    public void shouldHaveTheBoxTheExpectedWidth() {
        Geometry geom = (Geometry) app.getRootNode().getChild("Box");
        BoundingBox boundingBox = (BoundingBox) geom.getWorldBound();
        Assert.assertEquals("For box width",2.0f,boundingBox.getZExtent() * 2);
    }
  }
