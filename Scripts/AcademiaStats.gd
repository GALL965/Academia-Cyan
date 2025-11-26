extends Node

var total_partidas_runas := 0
var total_hechizos_runas := 0
var hechizos_correctos_runas := 0
var hechizos_incorrectos_runas := 0

func registrar_partida_runas(hechizos_totales: int, correctos: int, incorrectos: int) -> void:
	total_partidas_runas += 1
	total_hechizos_runas += hechizos_totales
	hechizos_correctos_runas += correctos
	hechizos_incorrectos_runas += incorrectos
