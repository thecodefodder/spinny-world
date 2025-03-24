package main

import "core:fmt"
import "vendor:raylib"

screenWidth: i32 = 800
screenHeight: i32 = 450

main :: proc() {
	raylib.InitWindow(screenWidth, screenHeight, "World")

	camera: raylib.Camera3D
	camera.position = raylib.Vector3{10.0, 10.0, 10.0}
	camera.target = raylib.Vector3{0.0, 0.0, 0.0}
	camera.up = raylib.Vector3{0.0, 1.0, 0.0}
	camera.fovy = 45.0
	camera.projection = raylib.CameraProjection.PERSPECTIVE

	cubePosition: raylib.Vector3 = raylib.Vector3{0.0, 0.0, 0.0}

	//NOTE: Adjust this to be 30 later?
	raylib.SetTargetFPS(60)

	for !raylib.WindowShouldClose() {
		raylib.BeginDrawing()

		raylib.BeginMode3D(camera)

		raylib.DrawSphere(cubePosition, 1.0, raylib.BLUE)

		raylib.ClearBackground(raylib.RAYWHITE)

		raylib.EndMode3D()

		raylib.DrawFPS(10, 10)

		raylib.EndDrawing()
	}

	raylib.CloseWindow()
}
