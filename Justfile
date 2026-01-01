# scenario helpers

NEW_PAGE_CONTENT := '''
<script lang=\"ts\">
	import { zod4 } from 'sveltekit-superforms/adapters';
</script>

<h1>Welcome to SvelteKit</h1>
<p>Visit <a href=\"https://svelte.dev/docs/kit\">svelte.dev/docs/kit</a> to read the documentation</p>
''' # fix VS Code syntax highlighting: '

init-project:
	yes | npx sv create --template minimal --types ts --no-add-ons --install npm .
	@echo "{{NEW_PAGE_CONTENT}}" > src/routes/+page.svelte

install-superforms:
	npm i -D sveltekit-superforms@2.29.1 zod

# scenarios

scenario-a:
	@just init-project
	rm -rf node_modules package-lock.json
	@just install-superforms

scenario-a1:
	@just init-project
	rm -rf node_modules package-lock.json
	@just install-superforms
	rm -rf node_modules package-lock.json
	npm i

scenario-a2:
	@just init-project
	rm -rf node_modules package-lock.json
	@just install-superforms
	rm -rf node_modules
	npm i

scenario-a3:
	@just init-project
	rm -rf node_modules package-lock.json
	@just install-superforms
	rm -rf package-lock.json
	npm i

scenario-b:
	@just init-project
	@just install-superforms

scenario-b1:
	@just init-project
	@just install-superforms
	rm -rf node_modules package-lock.json
	npm i

scenario-b2:
	@just init-project
	@just install-superforms
	rm -rf node_modules
	npm i

scenario-b3:
	@just init-project
	@just install-superforms
	rm -rf package-lock.json
	npm i

# orchestration

run:
	npm run dev

reset:
	git checkout "main"
	rm -rf node_modules/ .svelte-kit/

record-scenario NAME RESULT:
	git checkout -b "scenario-{{NAME}}"
	@just "scenario-{{NAME}}"
	git add .
	git commit -m "scenario-{{NAME}} ({{RESULT}})"
	@just run

delete-scenario NAME:
	git checkout "main"
	rm -rf node_modules/ .svelte-kit/
	git branch -d "scenario-{{NAME}}"
