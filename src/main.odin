package main

import "core:fmt"
import "vendor:raylib"
import "vendor:raylib/rlgl"

screenWidth: i32 = 800
screenHeight: i32 = 450
GLSL_VERSION: i32 = 330

main :: proc() {
	raylib.InitWindow(screenWidth, screenHeight, "World")

	earthTexture := raylib.LoadTexture("assets/2k_earth_daymap.jpg")

	// Skybox
	cube := raylib.GenMeshCube(1.0, 1.0, 1.0)
	skybox := raylib.LoadModelFromMesh(cube)

	skybox.materials[0].shader = raylib.LoadShader("assets/skybox.vs", "assets/skybox.fs")

	//skybox.materials[0].shader = raylib.LoadShader("", "")

	map_type := raylib.MaterialMapIndex.CUBEMAP
	//SetShaderValue(skybox.materials[0].shader, GetShaderLocation(skybox.materials[0].shader, "environmentMap"), (int[1]){ MATERIAL_MAP_CUBEMAP }, SHADER_UNIFORM_INT);
	raylib.SetShaderValue(
		skybox.materials[0].shader,
		raylib.GetShaderLocation(skybox.materials[0].shader, "environmentMap"),
		&map_type,
		raylib.ShaderUniformDataType.INT,
	)

	raylib.SetShaderValue(
		skybox.materials[0].shader,
		raylib.GetShaderLocation(skybox.materials[0].shader, "doGamma"),
		&map_type,
		raylib.ShaderUniformDataType.INT,
	)

	raylib.SetShaderValue(
		skybox.materials[0].shader,
		raylib.GetShaderLocation(skybox.materials[0].shader, "vflipped"),
		&map_type,
		raylib.ShaderUniformDataType.INT,
	)

	shdrCubemap := raylib.LoadShader("assets/cubemap.vs", "assets/cubemap.fs")

	raylib.SetShaderValue(
		shdrCubemap,
		raylib.GetShaderLocation(shdrCubemap, "equirectangularMap"),
		&map_type,
		raylib.ShaderUniformDataType.INT,
	)

	skybox_img: raylib.Image = raylib.LoadImage("assets/space_sb.png")
	skybox.materials[0].maps[raylib.MaterialMapIndex.CUBEMAP].texture = raylib.LoadTextureCubemap(
		skybox_img,
		raylib.CubemapLayout.CROSS_THREE_BY_FOUR,
	)
	raylib.UnloadImage(skybox_img)

	// End skybox

	// Setup camera
	camera: raylib.Camera3D
	camera.position = raylib.Vector3{0.0, 0.0, 0.0}
	camera.target = raylib.Vector3{1.0, 0.0, 0.0}
	camera.up = raylib.Vector3{0.0, 1.0, 0.0}
	camera.fovy = 90.0
	camera.projection = raylib.CameraProjection.PERSPECTIVE

	// Generate a mesh for the earth
	sphere: raylib.Mesh = raylib.GenMeshSphere(1.0, 32, 32)

	model: raylib.Model = raylib.LoadModelFromMesh(sphere)
	model.materials[0].maps[raylib.MaterialMapIndex.ALBEDO].texture = earthTexture

	raylib.SetTargetFPS(60)

	// the earth rotation
	rotationAngle: f32 = 0.0

	for !raylib.WindowShouldClose() {
		rotationAngle += raylib.GetFrameTime() * 0.5

		rotationMatrix := raylib.MatrixRotateY(rotationAngle)

		model.transform = rotationMatrix

		raylib.BeginDrawing()

		raylib.ClearBackground(raylib.BLACK)

		raylib.BeginMode3D(camera)

		// Draw skybox at a larger scale and disable depth writing
		rlgl.DisableBackfaceCulling()
		rlgl.DisableDepthMask()
		raylib.DrawModel(skybox, raylib.Vector3{0, 0, 0}, 100.0, raylib.WHITE)
		rlgl.EnableBackfaceCulling()
		rlgl.EnableDepthMask()

		// Draw earth model at a smaller scale and closer to the camera
		raylib.DrawModel(model, raylib.Vector3{3.0, 0.0, 0.0}, 0.5, raylib.WHITE)

		raylib.EndMode3D()

		raylib.DrawFPS(10, 10)

		raylib.EndDrawing()
	}

	raylib.UnloadShader(skybox.materials[0].shader)
	raylib.UnloadTexture(skybox.materials[0].maps[raylib.MaterialMapIndex.CUBEMAP].texture)
	raylib.UnloadTexture(earthTexture)
	raylib.UnloadModel(model)
	raylib.CloseWindow()
}
