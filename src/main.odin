package main

import "core:fmt"
import "vendor:raylib"

screenWidth: i32 = 800
screenHeight: i32 = 450

main :: proc() {
	raylib.InitWindow(screenWidth, screenHeight, "World")

	earthTexture := raylib.LoadTexture("assets/2k_earth_daymap.jpg")

	camera: raylib.Camera3D
	camera.position = raylib.Vector3{4.0, 4.0, 4.0}
	camera.target = raylib.Vector3{0.0, 0.0, 0.0}
	camera.up = raylib.Vector3{0.0, 1.0, 0.0}
	camera.fovy = 45.0
	camera.projection = raylib.CameraProjection.PERSPECTIVE

	sphere: raylib.Mesh = raylib.GenMeshSphere(1.0, 32, 32)

	model: raylib.Model = raylib.LoadModelFromMesh(sphere)
	model.materials[0].maps[raylib.MaterialMapIndex.ALBEDO].texture = earthTexture

	raylib.SetTargetFPS(60)

	for !raylib.WindowShouldClose() {
		raylib.BeginDrawing()

		raylib.ClearBackground(raylib.BLACK)

		raylib.BeginMode3D(camera)

		raylib.DrawModel(model, raylib.Vector3{0.0, 0.0, 0.0}, 1.0, raylib.WHITE)

		raylib.EndMode3D()

		raylib.DrawFPS(10, 10)

		raylib.EndDrawing()
	}

	raylib.UnloadTexture(earthTexture)
	raylib.UnloadModel(model)
	raylib.CloseWindow()
}
