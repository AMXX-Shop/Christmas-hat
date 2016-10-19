#include <amxmodx>
#include <reapi>

#pragma semicolon 1

new const HATS[][] = {
	"models/christmas_hat/deer.mdl", "models/christmas_hat/hat_t.mdl", "models/christmas_hat/hat_ct.mdl"
};

new g_MdlIndex[3], g_Ent[MAX_CLIENTS + 1];

public plugin_precache() {
	for(new i; i < sizeof HATS; i++) {
		g_MdlIndex[i] = precache_model(HATS[i]);
	}
}

public plugin_init() {
	register_plugin("Christmas hat", "0.1", "AMXX.Shop");
	RegisterHookChain(RG_CBasePlayer_Spawn, "RGCBasePlayerSpawnPost", 1);
}

public client_putinserver(id) {
	if(is_user_bot(id) || is_user_hltv(id)) {
		return;
	}
	CheckEnt(id);
	if((g_Ent[id] = rg_create_entity("info_target"))) {
		set_entvar(g_Ent[id], var_classname, "_christmas_hat_ent");
		set_entvar(g_Ent[id], var_movetype, MOVETYPE_FOLLOW);
		set_entvar(g_Ent[id], var_aiment, id);
	}
}

public client_disconnect(id) {
	CheckEnt(id);
}

public RGCBasePlayerSpawnPost(const id) {
	if(is_entity(g_Ent[id]) && is_user_alive(id)) {
		new Index = (8 / random_num(3, 4)) % 2 ? get_member(id, m_iTeam) : 0;
		set_entvar(g_Ent[id], var_model, HATS[Index]);
		set_entvar(g_Ent[id], var_modelindex, g_MdlIndex[Index]);
	}
}

CheckEnt(const id) {
	if(g_Ent[id] && is_entity(g_Ent[id])) {
		set_entvar(g_Ent[id], var_flags, FL_KILLME);
		set_entvar(g_Ent[id], var_nextthink, get_gametime());
		g_Ent[id] = 0;
	}
}