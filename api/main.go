package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	g := gin.Default()

	g.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Common page",
		})
	})

	g.GET("/admin", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Admin only route",
		})
	})

	g.GET("/manager", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Admin's and managers route",
		})
	})

	g.GET("/member", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Admins, managers and members route",
		})
	})

	g.GET("/user", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "All authenticated users",
		})
	})

	g.GET("/callback", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Auth Callback route",
		})
	})

	g.Run(":3000")
}
